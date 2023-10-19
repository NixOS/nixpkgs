{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, click
, rich
}:

buildPythonPackage rec {
  pname = "name-that-hash";
  version = "1.11.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "HashPals";
    repo = pname;
    rev = version;
    hash = "sha256-zOb4BS3zG1x8GLXAooqqvMOw0fNbw35JuRWOdGP26/8=";
  };

  # TODO remove on next update which bumps rich
  postPatch = ''
    substituteInPlace pyproject.toml --replace 'rich = ">=9.9,<11.0"' 'rich = ">=9.9"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    rich
  ];

  pythonImportsCheck = [ "name_that_hash" ];

  meta = with lib; {
    longDescription = "Don't know what type of hash it is? Name That Hash will name that hash type! Identify MD5, SHA256 and 300+ other hashes.";
    description = "Module and CLI for the identification of hashes";
    homepage = "https://github.com/HashPals/Name-That-Hash";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ eyjhb ];
  };
}
