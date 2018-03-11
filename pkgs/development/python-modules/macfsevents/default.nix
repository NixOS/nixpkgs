{ stdenv, buildPythonPackage, fetchPypi, darwin }:

buildPythonPackage rec {
  pname = "MacFSEvents";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "041yhfgl82p68q9fsixh8b6jl1ns7bvq8zd85dkdwlb06mmvc90k";
  };
  buildInputs = with darwin.apple_sdk.frameworks; [
    darwin.cf-private
    CoreServices
  ];

  meta = {
    description = "A python interface to file system observation primitives in Mac OS X";
    homepage = https://github.com/malthe/macfsevents;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    platforms = stdenv.lib.platforms.darwin;
  };
}
