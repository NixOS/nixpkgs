{ stdenv, mkFont, fetchzip }:

mkFont rec {
  pname = "fira-code";
  version = "5.2";

  src = fetchzip {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/Fira_Code_v${version}.zip";
    sha256 = "0dqy6w55jq542v11d0b2kjwvch9pp66p2y5s27dwl1z028ckhmfy";
    stripRoot = false;
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/tonsky/FiraCode";
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
