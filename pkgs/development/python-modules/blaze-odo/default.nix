{ lib
, buildPythonPackage
, fetchFromGitHub
, pandas
, datashape
, networkx
, toolz
}:

buildPythonPackage rec {
  pname = "blaze-odo";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "blaze";
    repo = "odo";
    rev = version;
    hash = "sha256-TYw6Ncc6MKYWU8FwpFk8ZEiqBuL8H8kqD/jndyF8eow=";
  };

  propagatedBuildInputs = [
    pandas
    datashape
    networkx
    toolz
  ];

  # ImportError: cannot import name 'Iterator' from 'collections'
  # pythonImportsCheck = [ "odo" ];
  doCheck = false;

  meta = with lib; {
    description = "Data migration for the Blaze project";
    homepage = "https://github.com/blaze/odo";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ Madouura ];
  };
}
