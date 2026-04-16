{
  fontbakery,
  lib,
  runCommand,
}:

let
  inherit (fontbakery) version src;
in

runCommand "fontbakery-tests" { meta.timeout = 5; } ''
  # Check the version matches what we packaged.
  ${fontbakery.exe} --version | grep -q "${version}"

  # Unpack src to get some test fonts.
  tar -xzf ${src} --strip-components=1 fontbakery-${version}/data/test

  # Run some font checks.
  ${fontbakery.exe} check-ufo --no-progress --no-colors data/test/test.ufo >>$out
  # TODO add more
''
