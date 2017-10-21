{ fetchFromGitHub }:
rec {
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ampas";
    repo = "CTL";
    rev = "ctl-${version}";
    sha256 = "0a698rd1cmixh3mk4r1xa6rjli8b8b7dbx89pb43xkgqxy67glwx";
  };
}
