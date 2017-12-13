{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchurl
, eject, pygit2, gitMinimal, git-annex }:

buildPythonPackage rec {
  pname = "git-annex-adapter";
  version = "0.2.0";
  name = "${pname}-${version}";

  disabled = (!isPy3k);

  # There is only a wheel on PyPI - build from source instead
  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sbgp4ivgw4m8nngrlb1f78xdnssh639c1khv4z98753w3sdsxdz";
  };

  prePatch = ''
    substituteInPlace git_annex_adapter/process.py \
      --replace "'git', 'annex'" "'${git-annex}/bin/git-annex'" \
      --replace "'git-annex'" "'${git-annex}/bin/git-annex'"
  '';

  # TODO: Remove for next version
  patches = fetchurl {
    url = "https://github.com/alpernebbi/git-annex-adapter/commit/9f64c4b99cae7b681820c6c7382e1e40489f4d1e.patch";
    sha256 = "1hbw8651amjskakvs1wv2msd1wryrq0vpryvbispg5267rs8q7hp";
  };

  nativeBuildInputs = [
    eject # `rev` is needed in tests/test_process.py
  ];

  propagatedBuildInputs = [ pygit2 gitMinimal ];

  buildInputs = [ git-annex ];

  checkPhase = ''
    python -m unittest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/alpernebbi/git-annex-adapter;
    description = "Call git-annex commands from Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
