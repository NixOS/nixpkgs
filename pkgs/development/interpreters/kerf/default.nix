{ lib, stdenv, fetchFromGitHub
, libedit, zlib, ncurses, expect

# darwin only below
, Accelerate, CoreGraphics, CoreVideo
}:

stdenv.mkDerivation rec {
  pname = "kerf";
  version = "unstable-2022-08-05";

  src = fetchFromGitHub {
    owner = "kevinlawler";
    repo  = "kerf1";
    rev   = "4ec5b592b310b96d33654d20d6a511e6fffc0f9d";
    hash  = "sha256-0sU2zOk5I69lQyrn1g0qsae7S/IBT6eA/911qp0GNkk=";
  };

  sourceRoot = "source/src";
  buildInputs = [ libedit zlib ncurses ]
    ++ lib.optional stdenv.isDarwin ([
      Accelerate
    ] ++ lib.optional stdenv.isx86_64 /* && isDarwin */ [
      CoreGraphics CoreVideo
    ]);

  checkInputs = [ expect ];
  doCheck = true;

  makeFlags = [ "kerf" "kerf_test" ];

  # avoid a huge amount of warnings to make failures clearer
  NIX_CFLAGS_COMPILE = map (x: "-Wno-${x}") [
    "void-pointer-to-int-cast"
    "format"
    "implicit-function-declaration"
    "gnu-variable-sized-type-not-at-end"
    "unused-result"
  ] ++ lib.optional stdenv.isDarwin [ "-fcommon" ];

  patchPhase = ''
    substituteInPlace ./Makefile \
      --replace 'CPUS ?=' 'CPUS = $(NIX_BUILD_CORES) #' \
      --replace 'termcap' 'ncurses'
  '';

  # the kerf executable uses ncurses to create a fancy terminal for input and
  # reads terminal keystrokes directly, so it doesn't read from stdin as
  # expected, hence why we use this fancy expect script to run the test exe and
  # send 'quit' to the prompt after it finishes.
  checkPhase = ''
    expect <<EOD
      set timeout 60
      spawn ./kerf_test
      expect {
        "Passed" {}
        "Failed" { exit 1 }
        timeout { exit 1 }
      }
      expect {
        "KeRF> " {send "quit\r"}
        timeout { exit 1 }
      }
      expect {
        "\[DEBUG\] OK: Done OK." {}
        "\[DEBUG\] FAILED: Debug failure." { exit 1 }
        timeout { exit 1 }
      }
      exit 0
    EOD
  '';

  installPhase = "install -D kerf $out/bin/kerf";

  meta = with lib; {
    description = "Columnar tick database and time-series language";
    longDescription = ''
      Kerf is a columnar tick database and small programming
      language that is a superset of JSON and SQL. It can be
      used for local analytics, timeseries, logfile processing,
      and more.
    '';
    license = with licenses; [ bsd2 ];
    homepage = "https://github.com/kevinlawler/kerf1";
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];

    # aarch64-linux seems hopeless, with over 2,000 warnings
    # generated?
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
