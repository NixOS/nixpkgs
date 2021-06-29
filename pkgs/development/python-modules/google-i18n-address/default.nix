{ buildPythonPackage, fetchPypi, fetchpatch, lib, requests, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8454a58f254a29988b8d1ca9ab663fd28a1f392a3d29b844d8824807db6333d7";
  };

  patches = [
    # fix compatibility with Python 3.9
    (fetchpatch {
      url = "https://github.com/mirumee/google-i18n-address/commit/b1d63d980e8b1a666e312e1c05c9037e2920685b.patch";
      sha256 = "0lhsvkcgwz3i4az5hj8irbn8mj4b8yffq03isa18qp3z616adlrp";
    })
  ];

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook mock ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = "https://github.com/mirumee/google-i18n-address";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.bsd3;
  };
}
