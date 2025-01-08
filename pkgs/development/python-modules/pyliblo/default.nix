{
  lib,
  buildPythonPackage,
  fetchurl,
  isPyPy,
  liblo,
  cython_0,
}:

buildPythonPackage rec {
  pname = "pyliblo";
  version = "0.10.0";
  format = "setuptools";
  disabled = isPyPy;

  src = fetchurl {
    url = "http://das.nasophon.de/download/${pname}-${version}.tar.gz";
    sha256 = "13vry6xhxm7adnbyj28w1kpwrh0kf7nw83cz1yq74wl21faz2rzw";
  };

  patches = [
    (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/community/py3-pyliblo/py3.11.patch?id=a7e1eca5533657ddd7e37c43e67e8126e3447258";
      hash = "sha256-4yCWNQaE/9FHGTVuvNEimBNuViWZ9aSJMcpTOP0fnM0=";
    })
    # Fix compile error due to  incompatible pointer type 'lo_blob_dataptr'
    (fetchurl {
      url = "https://github.com/dsacre/pyliblo/commit/ebbb255d6a73384ec2560047eab236660d4589db.patch?full_index=1";
      hash = "sha256-ZBAmBxSUT2xgoDVqSjq8TxW2jz3xR/pdCf2O3wMKvls=";
    })
  ];

  build-system = [ cython_0 ];

  buildInputs = [ liblo ];

  meta = with lib; {
    homepage = "https://das.nasophon.de/pyliblo/";
    description = "Python wrapper for the liblo OSC library";
    license = licenses.lgpl21Only;
  };
}
