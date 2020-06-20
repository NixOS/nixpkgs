{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, pyserial }:

buildPythonPackage rec {
  pname = "pyserial-asyncio";
  version = "0.4";

  disabled = !isPy3k; # Doesn't support python older than 3.4

  buildInputs = [ pyserial ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vlsb0d03krxlj7vpvyhpinnyxyy8s3lk5rs8ba2932dhyl7f1n4";
  };

  meta = with stdenv.lib; {
    description = "asyncio extension package for pyserial";
    homepage = "https://github.com/pyserial/pyserial-asyncio";
    license = licenses.bsd3;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
