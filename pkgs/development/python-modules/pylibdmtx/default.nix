{
  fetchFromGitHub,
  buildPythonPackage,
  pillow,
  numpy,
  libdmtx,
  lib,
}:

buildPythonPackage rec {
  pname = "pylibdmtx";
  version = "0.1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "NaturalHistoryMuseum";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vNWzhO4V0mj4eItZ0Z5UG9RBCqprIcgMGNyIe1+mXWY=";
  };

  # Change:
  # def load():
  #     """Loads the libdmtx shared library.
  #
  # To:
  # def load():
  #     return cdll.LoadLibrary("/nix/store/.../lib/libdmtx.so")
  #     """Loads the libdmtx shared library.
  postPatch = ''
    sed -i '\#def load.*#a\    return cdll.LoadLibrary("${libdmtx}/lib/libdmtx.so")' \
        pylibdmtx/dmtx_library.py

    # Checks that the loader works in various scenarios, but we just
    # forced it to only work one way.
    rm pylibdmtx/tests/test_dmtx_library.py
  '';

  propagatedBuildInputs = [
    pillow
    numpy
  ];

  pythonImportsCheck = [ "pylibdmtx" ];

  meta = with lib; {
    description = "Read and write Data Matrix barcodes from Python 2 and 3 using the libdmtx library";
    homepage = "https://github.com/NaturalHistoryMuseum/pylibdmtx/";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
  };
}
