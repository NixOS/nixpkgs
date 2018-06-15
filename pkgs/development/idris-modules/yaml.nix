{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, lightyear
, lib
, idris
}:
build-idris-package  {
  name = "yaml";
  version = "2018-01-25";

  idrisDeps = [ prelude contrib lightyear ];

  src = fetchFromGitHub {
    owner = "Heather";
    repo = "Idris.Yaml";
    rev = "5afa51ffc839844862b8316faba3bafa15656db4";
    sha256 = "1g4pi0swmg214kndj85hj50ccmckni7piprsxfdzdfhg87s0avw7";
  };

  meta = {
    description = "Idris YAML lib";
    homepage = https://github.com/Heather/Idris.Yaml;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
