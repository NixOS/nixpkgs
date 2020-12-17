{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstring";
  version = "3.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jl6192dwrlm5ybkbh7ywmyaymrc3cmz9y07nm7qdli9n9rfpwzx";
  };

  meta = with stdenv.lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
