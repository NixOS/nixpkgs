{ stdenv
, buildPythonPackage
, isPy33
, fetchgit
, cython
}:

buildPythonPackage rec {
  pname = "rencode";
  version = "git20150810";
  disabled = isPy33;

  src = fetchgit {
    url = https://github.com/aresch/rencode;
    rev = "b45e04abdca0dea36e383a8199783269f186c99e";
    sha256 = "b4bd82852d4220e8a9493d3cfaecbc57b1325708a2d48c0f8acf262edb10dc40";
  };

  buildInputs = [ cython ];

  meta = with stdenv.lib; {
    homepage = https://github.com/aresch/rencode;
    description = "Fast (basic) object serialization similar to bencode";
    license = licenses.gpl3;
  };

}
