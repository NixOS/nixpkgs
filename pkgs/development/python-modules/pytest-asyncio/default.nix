{ stdenv, buildPythonPackage, fetchurl, pytest, isPy3k }:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-asyncio";
  version = "0.5.0";

  disabled = !isPy3k;

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "03sxq8fglr4lw4y6wqlbli9ypr65fxzx6hlpn5wpccx8v5472iff";
  };

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = https://github.com/pytest-dev/pytest-asyncio;
  };
}
