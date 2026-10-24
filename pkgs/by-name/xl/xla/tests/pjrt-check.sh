# Invoked by the Nix-built tester with the selected package and platform.
set -euo pipefail
runner=$1
plugin=$2
platform=$3
shift 3
if (( $# > 1 )); then
  echo 'Usage: xla-pjrt-PLATFORM [LOG_DIRECTORY]' >&2
  exit 2
fi
logs=${1:-$(mktemp -d -t "xla-pjrt-$platform.XXXXXXXX")}
mkdir -p "$logs"
echo "PJRT plugin: $plugin"
echo "Logs: $logs"
"$runner" "$plugin" "$platform" 2>&1 | tee "$logs/positive.log"
grep -F 'Transcendental result transferred: f32[2,3]' "$logs/positive.log"
grep -F "PASS: $platform StableHLO compile/execute/readback" "$logs/positive.log"
if "$runner" "$plugin" "$platform" --wrong-expected > "$logs/wrong-expected.log" 2>&1; then
  echo 'incorrect expected value unexpectedly passed' >&2
  exit 1
else
  status=$?
fi
cat "$logs/wrong-expected.log"
echo "wrong-expected exit=$status"
test "$status" -eq 1
grep -F 'Execution completed' "$logs/wrong-expected.log"
grep -F 'Result transferred: f32[2,3] 3 -6 6 1 4 48' "$logs/wrong-expected.log"
grep -F 'FAIL: value mismatch at element 0' "$logs/wrong-expected.log"
if [[ $platform == cpu ]]; then
  if "$runner" "$plugin" cuda > "$logs/wrong-platform.log" 2>&1; then
    echo 'CPU plugin unexpectedly satisfied CUDA request' >&2
    exit 1
  else
    status=$?
  fi
  cat "$logs/wrong-platform.log"
  echo "wrong-platform exit=$status"
  test "$status" -eq 1
  grep -F 'FAIL: requested platform cuda, got cpu' "$logs/wrong-platform.log"
fi
