{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  react,
}:

buildDunePackage rec {
  pname = "reactiveData";
  version = "0.3";
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "reactiveData";
    rev = version;
    sha256 = "sha256-imUphE1vMe3bYqHhgTuGT+B7uLn75acX6fAwBLh1tz4=";
  };

  propagatedBuildInputs = [ react ];

  meta = with lib; {
    description = "OCaml module for functional reactive programming (FRP) based on React";
    homepage = "https://github.com/ocsigen/reactiveData";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
  };
}
