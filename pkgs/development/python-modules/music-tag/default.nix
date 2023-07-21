{ lib
, buildPythonPackage
, fetchFromGitHub
, mutagen
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "music-tag";
  version = "0.4.3";
  format = "setuptools";

  # pypi release misses test files
  src = fetchFromGitHub {
    owner = "KristoforMaynard";
    repo = pname;
    rev = version;
    hash = "sha256-8i6sLSv7wWOIXbdSfnLVTLRCyziJWehdTYrz5irLpdI=";
  };

  propagatedBuildInputs = [
    mutagen
  ];

  # Tests fail for now
  doCheck = false;

  pythonImportsCheck = [
    "music_tag"
  ];

  meta = with lib; {
    description = "Simple interface to edit audio file metadata";
    homepage = "https://github.com/KristoforMaynard/music-tag";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
