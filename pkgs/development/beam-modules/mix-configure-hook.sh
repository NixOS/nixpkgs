# Added 2026-02-12 for external users
echo "mix-configure-hook.sh has been removed and is now a setup hook.
  Add 'beamPackages.mixBuildDirHook' to 'nativeBuildInputs' instead.
" >&2
exit 1
