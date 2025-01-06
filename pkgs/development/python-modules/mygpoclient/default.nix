{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  minimock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mygpoclient";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "mygpoclient";
    rev = version;
    hash = "sha256-McHllitWiBiCdNuJlUg6K/vgr2l3ychu+KOx3r/UCv0=";
  };

  postPatch = ''
    substituteInPlace mygpoclient/*_test.py \
      --replace-quiet "assertEquals" "assertEqual" \
      --replace-quiet "assert_" "assertTrue"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mygpoclient" ];

  nativeCheckInputs = [
    minimock
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Gpodder.net client library";
    longDescription = ''
      The mygpoclient library allows developers to utilize a Pythonic interface
      to the gpodder.net web services.
    '';
    homepage = "https://github.com/gpodder/mygpoclient";
    license = with licenses; [ gpl3 ];
    maintainers = [ ];
  };
}
