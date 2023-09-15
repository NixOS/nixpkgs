{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, bidict
, bubop
}:

buildPythonPackage rec {
  pname = "item-synchronizer";
  version = "1.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "item_synchronizer";
    rev = "v${version}";
    hash = "sha256-97xshwhRKXagZZNCqNiMhe31L1Yzvdo9aGT5fMi4zFs=";
  };

  patches = [
    # https://github.com/bergercookie/item_synchronizer/pull/1
    ./build-using-poetry-core.patch
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bidict
    bubop
  ];

  pythonImportsCheck = [ "item_synchronizer" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/bergercookie/item_synchronizer";
    changelog = "https://github.com/bergercookie/item_synchronizer/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
