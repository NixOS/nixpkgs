{ stdenv
, buildPythonPackage
, fetchPypi
, pygments
, isPy3k
}:

buildPythonPackage rec {
  pname = "pygments_better_html";
  version = "0.1.4";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "028szd3k295yhz943bj19i4kx6f0pfh1fd2q14id0g84dl4i49dm";
  };

  propagatedBuildInputs = [ pygments ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pygments_better_html" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Kwpolska/pygments_better_html";
    description = "Improved line numbering for Pygments’ HTML formatter.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
