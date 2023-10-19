{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "py-radix-sr";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SEKOIA-IO";
    repo = "py-radix";
    rev = "v${version}";
    hash = "sha256-aHV+NvPR4Gyk6bEpCftgBylis9rU7BWLpBMatjP4QmE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "name='py-radix'" "name='py-radix-sr'"
  '';

  pythonImportsCheck = [ "radix" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python radix tree for IPv4 and IPv6 prefix matching";
    homepage = "https://github.com/SEKOIA-IO/py-radix";
    license = with licenses; [ isc bsdOriginal ];
    maintainers = with maintainers; [ netali ];
  };
}
