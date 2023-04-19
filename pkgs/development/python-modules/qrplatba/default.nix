{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry-core
, qrcode
}:

buildPythonPackage rec {
  pname = "qrplatba";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ViktorStiskala";
    repo = "python-qrplatba";
    rev = version;
    hash = "sha256-6CUQxQsuTvoYGh5R5RrYIEcbovkBsRir535CD1oKugM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    qrcode
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "QR platba SVG QR code generator";
    homepage = "https://qr-platba.cz/pro-vyvojare";
    changelog = "https://github.com/ViktorStiskala/python-qrplatba/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
