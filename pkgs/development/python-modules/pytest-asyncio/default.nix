{ stdenv, buildPythonPackage, fetchurl, pytest, isPy3k }:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-asyncio";
  version = "0.6.0";

  disabled = !isPy3k;

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "e5c6786ece4b3bbb0cca1bf68bf089756a62760e3764dc84eaee39bfab70289b";
  };

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = https://github.com/pytest-dev/pytest-asyncio;
  };
}
