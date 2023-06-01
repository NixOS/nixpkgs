{ python3
, lib
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nemo-emblems";
  version = "5.6.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = version;
    sha256 = "sha256-cxutiz5bc/dZ9D7XzvMWodWNYvNJPj+5IhJDPJwnb5I=";
  };

  sourceRoot = "${src.name}/nemo-emblems";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/share" "share"
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-emblems";
    description = "Change a folder or file emblem in Nemo";
    longDescription = ''
      Nemo extension that allows you to change folder or file emblems.
      When adding this to nemo-with-extensions you also need to add nemo-python.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
