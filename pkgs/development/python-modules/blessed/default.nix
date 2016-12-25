{
stdenv, pkgs, python, wrapPython, buildPythonPackage,
pytest, mock,
wcwidth, six
}:

buildPythonPackage rec {
  pname = "blessed";
  name = "${pname}-${version}";
  version = "1.14.1";
  src = pkgs.fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "0wy0na399swybp5bzys31pn57vg34bjsl0kv5zf496996gc8k8jq";
  };
  doCheck = false;
  checkPhase = ''
    py.test
  '';
  meta = with stdenv.lib; {
    description = "A thin, practical wrapper around terminal styling, screen positioning, and keyboard input.";
    homepage    = "https://github.com/jquast/blessed";
    license     = licenses.mit;
    platforms   = platforms.linux;
  };
  buildInputs = [ pytest mock ];
  propagatedBuildInputs = [ wcwidth six ];
  maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
