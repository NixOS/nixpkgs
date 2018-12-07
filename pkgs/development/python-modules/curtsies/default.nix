{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, pythonOlder, blessings, mock, nose, pyte, wcwidth, typing }:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "89c802ec051d01dec6fc983e9856a3706e4ea8265d2940b1f6d504a9e26ed3a9";
  };

  patches = [
    # Fix dependency on typing. Remove with the next release
    (fetchpatch {
      url = https://github.com/bpython/curtsies/commit/217b4f83e954837f8adc4c549c1f2f9f2bb272a7.patch;
      sha256 = "1d3zwx9c7i0drb4nvydalm9mr83jrvdm75ffgisri89h337hiffs";
    })
  ];

  propagatedBuildInputs = [ blessings wcwidth ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [ mock pyte nose ];

  checkPhase = ''
    nosetests tests
  '';

  meta = with stdenv.lib; {
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = https://github.com/bpython/curtsies;
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
