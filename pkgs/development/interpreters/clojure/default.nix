{ stdenv, fetchFromGitHub, fetchMaven, maven }:

stdenv.mkDerivation rec {
  name = "clojure-${version}";
  version = "1.9.0.273";

  src = fetchFromGitHub {
    owner = "clojure";
    repo = "brew-install";
    rev = version;
    sha256 = "06cfr2jjwvqml19na5220dgyjy4dhkv27l0b2ck02fy5a796vh84";
  };

  deps = fetchMaven {
    inherit src;
    sha256 = "0h80p8jl9w59hc0xrr6lswznh2hi8bjj8h99p2jpjnqfcwdyxrnd";
  };

  nativeBuildInputs = [ maven ];

  buildPhase = "mvn -o -Dmaven.repo.local=${deps} package";

  installPhase = ''
    local prefix=$out/share/clojure
    local source=target/classes

    substituteInPlace $source/clojure --replace PREFIX $prefix
    install -Dt $out/bin $source/{clj,clojure}

    mkdir -p $prefix $prefix/libexec
    cp target/clojure-tools-${version}.jar $prefix/libexec
    cp $source/{,example-}deps.edn $prefix
  '';

  meta = with stdenv.lib; {
    description = "The Clojure programming language";
    homepage = https://clojure.org;
    license = licenses.epl10;
    maintainers = with maintainers; [ the-kenny yegortimoshenko ];
    platforms = platforms.unix;
  };
}
