{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  react,
}:

buildDunePackage (finalAttrs: {
  pname = "reactiveData";
  version = "0.3.1";
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "reactiveData";
    rev = finalAttrs.version;
    sha256 = "sha256-MO9WMe1k2QcC5RynE6uZHohmu3QlpTHvAkvQNgu3P90=";
  };

  propagatedBuildInputs = [ react ];

  meta = {
    description = "OCaml module for functional reactive programming (FRP) based on React";
    homepage = "https://github.com/ocsigen/reactiveData";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
