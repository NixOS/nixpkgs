{ stdenv, lib, fetchFromGitHub, fetchzip, makeWrapper, python27withPackages }:
let
  findbugs = fetchzip {
    name = "findbugs-3.0.0";
    url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/findbugs-3.0.0.zip;
    sha256 = "0sf5f9h1s6fmhfigjy81i109j1ani5kzdr4njlpq0mnkkh9fpr7m";
  };
in
stdenv.mkDerivation rec {
  version = "5.261.2";
  pname = "mx";
  src = fetchFromGitHub {
    owner = "graalvm";
    repo = "mx";
    rev = version;
    sha256 = "09bghly7bgf90k8rdp6r6pimpiaqvrs4vljz79rgylnzw6kf3p74";
  };
  buildInputs = [ python27withPackages ];
  nativeBuildInputs = [ makeWrapper ];
  prePatch = ''
    cp mx.py bak_mx.py
  '';
  patches = [ ./mx.py.patch ];
  postPatch = ''
    mv mx.py internal_mx.py
    mv bak_mx.py mx.py
  '';
  buildPhase = ''
    substituteInPlace mx --replace /bin/pwd pwd

    # avoid crash with 'ValueError: ZIP does not support timestamps before 1980'
    substituteInPlace internal_mx.py --replace \
      'zipfile.ZipInfo(arcname, time.localtime(getmtime(join(root, f)))[:6])' \
      'zipfile.ZipInfo(arcname, time.strptime ("1 Jan 1980", "%d %b %Y"       )[:6])'
  '';
  installPhase = ''
    mkdir -p $out/bin $out/shared/graalvm/mx
    cp -dpR * $out/shared/graalvm/mx

    makeWrapper ${python27withPackages}/bin/python $out/bin/mx \
      --add-flags "$out/shared/graalvm/mx/mx.py" \
      --prefix PATH : ${lib.makeBinPath [ python27withPackages ]} \
      --set    FINDBUGS_HOME ${findbugs}

    makeWrapper ${python27withPackages}/bin/python $out/bin/mx-internal \
      --add-flags "$out/shared/graalvm/mx/internal_mx.py" \
      --prefix PATH : ${lib.makeBinPath [ python27withPackages ]} \
      --set    FINDBUGS_HOME ${findbugs}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/graalvm/mx;
    description = "Command-line tool used for the development of Graal projects";
    license = licenses.gpl2;
    platforms = python27withPackages.meta.platforms;
  };
}
