{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, numpy
, multipledispatch
, python-dateutil
}:

let
  # Fetcher function looks similar to fetchPypi.
  # Allows for easier overriding, without having to know
  # how the source is actually fetched.
  fetcher = {pname, version, sha256}: fetchFromGitHub {
    owner = "blaze";
    repo = pname;
    rev = version;
    inherit sha256;
  };

in buildPythonPackage rec {
  pname = "datashape";
  version = "0.5.4";

  src = fetcher {
    inherit pname version;
    sha256 = "0rhlj2kjj1vx5m73wnc5518rd6cs1zsbgpsvzk893n516k69shcf";
  };

  nativeCheckInputs = [ pytest mock ];
  propagatedBuildInputs = [ numpy multipledispatch python-dateutil ];

  # Disable several tests
  # https://github.com/blaze/datashape/issues/232
  checkPhase = ''
    pytest --ignore datashape/tests/test_str.py \
           --ignore datashape/tests/test_user.py
  '';

  # https://github.com/blaze/datashape/issues/238
  PYTEST_ADDOPTS = "-k 'not test_record and not test_tuple'";

  meta = {
    homepage = "https://github.com/ContinuumIO/datashape";
    description = "A data description language";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
