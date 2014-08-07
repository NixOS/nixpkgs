{ ruby, callPackage }:

let
  buildRubyGem = callPackage ./gem.nix { inherit ruby; };
in rec {
  inherit buildRubyGem;

  builder = buildRubyGem {
    name = "builder-3.2.2";
    sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    doCheck = false;
  };

  bundler = buildRubyGem {
    name = "bundler-1.6.5";
    sha256 = "1s4x0f5by9xs2y24jk6krq5ky7ffkzmxgr4z1nhdykdmpsi2zd0l";
    dontPatchShebangs = 1;
    checkPhase = ":";
  };

  capistrano = buildRubyGem {
    name = "capistrano-3.2.1";
    sha256 = "0jcx8jijbvl05pjd7jrzb1sf968vjzpvb190d1kfa968hfc92lm0";
    gemPath = [ colorize i18n net_scp net_ssh rake sshkit ];
    doCheck = false;
  };

  colorize = buildRubyGem {
    name = "colorize-0.7.3";
    sha256 = "0hccxpn0gryhdpyymkr7fnv2khz051f5rpw4xyrp9dr53b7yv3v2";
  };

  i18n = buildRubyGem {
    name = "i18n-0.6.11";
    sha256 = "0fwjlgmgry2blf8zlxn9c555cf4a16p287l599kz5104ncjxlzdk";
  };

  json = buildRubyGem {
    name = "json-1.8.1";
    sha256 = "0002bsycvizvkmk1jyv8px1hskk6wrjfk4f7x5byi8gxm6zzn6wn";
    doCheck = false;
  };

  net_scp = buildRubyGem {
    name = "net-scp-1.2.1";
    sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
    gemPath = [ net_ssh ];
    doCheck = false;
  };

  net_ssh = buildRubyGem {
    name = "net-ssh-2.9.1";
    sha256 = "1vscp4r58jisiigqc6d6752w19m1m6hmi3jkzmp3ydxai7h3jb2j";
    doCheck = false;
  };

  rake = buildRubyGem {
    name = "rake-10.3.2";
    sha256 = "0nvpkjrpsk8xxnij2wd1cdn6arja9q11sxx4aq4fz18bc6fss15m";
    gemPath = [ bundler ];
    checkPhase = ":";
  };

  sshkit = buildRubyGem {
    name = "sshkit-1.5.1";
    sha256 = "0lyd77b43dh897lx8iqdm9284ara7076nahmlis33qkfjfs105dy";
    gemPath = [ bundler colorize net_scp net_ssh ];
    doGitPrecheckHack = true;
  };
}
