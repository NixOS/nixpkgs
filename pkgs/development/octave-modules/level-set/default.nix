{
  buildOctavePackage,
  lib,
  fetchgit,
  automake,
  autoconf,
  autoconf-archive,
  parallel,
}:

buildOctavePackage rec {
  pname = "level-set";
  version = "2019-04-13";

  src = fetchgit {
    url = "https://git.code.sf.net/p/octave/${pname}";
    rev = "dbf46228a7582eef4fe5470fd00bc5b421dd33a5";
    sha256 = "14qwa4j24m2j7njw8gbagkgmp040h6k0h7kyrrzgb9y0jm087qkl";
    fetchSubmodules = false;
  };

  # The monstrosity of a regex below is to ensure that only error() calls are
  # corrected to have a %s format specifier. However, logic_error() also
  # exists, (a simple regex also matches that), but logic_error() doesn't
  # require a format specifier. So, this regex was born to handle that...
  postPatch = ''
    substituteInPlace build.sh --replace "level-set-0.3.1" "${pname}-${version}" \
                               --replace "\`pwd\`" '/build'
    sed -i -E 's#[^[:graph:]]error \(# error \(\"%s\", #g' src/*.cpp
  '';

  nativeBuildInputs = [
    automake
    autoconf
    autoconf-archive
  ];

  requiredOctavePackages = [
    parallel
  ];

  preBuild = ''
    mkdir -p $out
    source ./build.sh
    cd -
  '';

  meta = {
    name = "Level Set";
    homepage = "https://gnu-octave.github.io/packages/level-set/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Routines for calculating the time-evolution of the level-set equation and extracting geometric information from the level-set function";
    # Got broke with octave 8.x update, and wasn't updated since 2019
    broken = true;
  };
}
