{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "c7329055e2aeb253a947e5cc876586ff4ca19199";
  name = "gox-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/mitchellh/gox";
  src = fetchFromGitHub {
    inherit rev;
    owner = "mitchellh";
    repo = "gox";
    sha256 = "0zhb88jjxqn3sdc4bpzvajqvgi9igp5gk03q12gaksaxhy2wl4jy";
  };

  buildInputs = [ iochan ];

  propagatedBuildInputs = [ go ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "A simple, no-frills tool for Go cross compilation that behaves a lot like standard go build";
    homepage    = https://github.com/mitchellh/gox;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.unix;
  };
}
