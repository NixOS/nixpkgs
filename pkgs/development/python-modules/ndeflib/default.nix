{ buildPythonPackage
, fetchPypi
, fetchpatch
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ndeflib";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HVaChVi5sW8oIqQFGCQ0Y0e2at9TIOqGBwdItvJFSog";
  };

  patches = [
    # test reliability fix made after version 0.3.3, but 0.3.3 is the last one in pypi
    (fetchpatch {
      name = "struct.unpack_from-exception-message-has-changed";
      url = "https://github.com/nfcpy/ndeflib/commit/f9e40f436ef0543148ae227c9e8a46b17e2ffc98.patch";
      hash = "sha256-3uHy/1KsQJ0ERaKmLNbUhM1K+oMawwLTjfsihoSIIFI=";
    })
  ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "NFC Data Exchange Format decoder and encoder";
    homepage = "https://github.com/nfcpy/ndeflib";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      snicket2100
    ];
  };
}
