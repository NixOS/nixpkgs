{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "coda";
  version = "2018-01-25";

  ipkgName = "Coda";

  src = fetchFromGitHub {
    owner = "ostera";
    repo = "idris-coda";
    rev = "0d8b29b7b73aa1ea80bf216e5e6dea5e81156e32";
    sha256 = "07wps3pyp4ph0vj3640x561gkjkbcdq1if9h6sjjb30924sbdxfg";
  };

  meta = {
    description = "Some Idris libraries including nodejs bindings and ISO8601 Date and Time";
    homepage = "https://github.com/ostera/idris-coda";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
