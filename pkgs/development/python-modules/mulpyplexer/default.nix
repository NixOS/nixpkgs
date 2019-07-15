{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "mulpyplexer";
  version = "0.08";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca930b229e21fe0ed259788e2d871eb13e54d17e29d7f25347573ae87768c5fe";
  };

  meta = with lib; {
    description = "Multiplex interactions with lists of python objects";
    homepage = "https://github.com/zardus/mulpyplexer";
    license = licenses.bsd2;
    maintainers = [ maintainers.pamplemousse ];
  };
}
