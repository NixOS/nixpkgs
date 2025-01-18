{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  mew,
  react,
}:

buildDunePackage rec {
  pname = "mew_vi";
  version = "0.5.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "kandu";
    repo = pname;
    rev = version;
    sha256 = "0lihbf822k5zasl60w5mhwmdkljlq49c9saayrws7g4qc1j353r8";
  };

  propagatedBuildInputs = [
    mew
    react
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    license = licenses.mit;
    description = "Modal Editing Witch, VI interpreter";
    maintainers = [ maintainers.vbgl ];
  };

}
