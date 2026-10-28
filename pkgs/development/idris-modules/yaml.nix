{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lightyear,
  lib,
}:
build-idris-package {
  pname = "yaml";
  version = "2018-01-25";

  ipkgName = "Yaml";
  idrisDeps = [
    contrib
    lightyear
  ];

  src = fetchFromGitHub {
    owner = "Heather";
    repo = "Idris.Yaml";
    rev = "5afa51ffc839844862b8316faba3bafa15656db4";
    hash = "sha256-h28F9EEPuvab6zrfeE+0k1XGQJGwINnsJEG8yjWIl7w=";
  };

  meta = {
    description = "Idris YAML lib";
    homepage = "https://github.com/Heather/Idris.Yaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
