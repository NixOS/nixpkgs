{ runCommand
, fontbakery
}:

let
  inherit (fontbakery) pname version src;
in

runCommand "${pname}-tests" { meta.timeout = 5; } ''
  # Check the version matches what we packaged.
  ${fontbakery}/bin/fontbakery --version | grep -q "${version}"

  # Can it list its own subcommands?
  ${fontbakery}/bin/fontbakery --list-subcommands >>$out

  # Unpack src to get some test fonts.
  tar -xzf ${src} --strip-components=1 ${pname}-${version}/data/test

  # Run some font checks.
  ${fontbakery}/bin/fontbakery check-ufo-sources --no-progress --no-colors data/test/test.ufo >>$out
  # TODO add more
''
