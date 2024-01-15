{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "hexdump";
  version = "3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-14GkOwwWrOP5Nmqt5z6K06e9UTfVjwtFqy0/VIdvINs=";
    extension = "zip";
  };

  # the source zip has no prefix, so everything gets unpacked to /build otherwise
  unpackPhase = ''
    runHook preUnpack
    mkdir source
    pushd source
    unzip $src
    popd
    runHook postUnpack
  '';

  sourceRoot = "source";

  pythonImportsCheck = [ "hexdump" ];

  meta = with lib; {
    description = "Library to dump binary data to hex format and restore from there";
    homepage = "https://pypi.org/project/hexdump/"; # BitBucket site returns 404
    license = licenses.publicDomain;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
