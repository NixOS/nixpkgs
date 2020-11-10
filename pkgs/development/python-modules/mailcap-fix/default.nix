{ stdenv
, buildPythonPackage
, fetchPypi
, isPy36
}:

buildPythonPackage rec {
  pname = "mailcap-fix";
  version = "1.0.1";
  disabled = isPy36; # this fix is merged into python 3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "02lijkq6v379r8zkqg9q2srin3i80m4wvwik3hcbih0s14v0ng0i";
  };

  meta = with stdenv.lib; {
    description = "A patched mailcap module that conforms to RFC 1524";
    homepage = "https://github.com/michael-lazar/mailcap_fix";
    license = licenses.unlicense;
  };

}
