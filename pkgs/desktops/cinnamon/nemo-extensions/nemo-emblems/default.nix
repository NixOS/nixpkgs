{ python3
, lib
, fetchFromGitHub
}:

let
  srcs = import ../srcs.nix { inherit fetchFromGitHub; };
in
python3.pkgs.buildPythonApplication rec {
  pname = "nemo-emblems";
  inherit (srcs) version src;

  format = "setuptools";

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
