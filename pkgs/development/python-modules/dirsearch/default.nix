{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  # deps
  /*
    ntlm-auth is in the requirements.txt, however nixpkgs tells me
    > ntlm-auth has been removed, because it relies on the md4 implementation provided by openssl. Use pyspnego instead.
    Not sure if pyspnego is a drop in replacement.
    The simple functionality dirsearch seems not to depend on this package.
  */
  #ntlm-auth,
  #pyspnego,
  beautifulsoup4,
  certifi,
  cffi,
  chardet,
  charset-normalizer,
  colorama,
  cryptography,
  defusedxml,
  idna,
  jinja2,
  markupsafe,
  pyopenssl,
  pyparsing,
  pysocks,
  requests,
  requests-ntlm,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "dirsearch";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "maurosoria";
    repo = "dirsearch";
    rev = "v${version}";
    hash = "sha256-eXB103qUB3m7V/9hlq2xv3Y3bIz89/pGJsbPZQ+AZXs=";
  };

  # setup.py does some weird stuff with mktemp
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'os.chdir(env_dir)' "" \
      --replace-fail 'shutil.copytree(os.path.abspath(os.getcwd()), os.path.join(env_dir, "dirsearch"))' ""
  '';

  dependencies = [
    # maybe needed, see above
    #pyspnego
    #ntlm-auth
    beautifulsoup4
    certifi
    cffi
    chardet
    charset-normalizer
    colorama
    cryptography
    defusedxml
    idna
    jinja2
    markupsafe
    pyopenssl
    pyparsing
    pysocks
    requests
    requests-ntlm
    setuptools
    urllib3
  ];

  # the library files get installed in the wrong location
  # and dirsearch.py, __init__.py and db/ are missing
  postInstall = ''
    dirsearchpath=$out/lib/python${lib.versions.majorMinor python.version}/site-packages/
    mkdir -p $dirsearchpath/dirsearch
    mv $dirsearchpath/{lib,dirsearch}
    cp $src/{dirsearch,__init__}.py $dirsearchpath/dirsearch
    cp -r $src/db $dirsearchpath/dirsearch
  '';

  meta = {
    changelog = "https://github.com/maurosoria/dirsearch/releases/tag/${version}";
    description = "command-line tool for brute-forcing directories and files in webservers, AKA a web path scanner";
    homepage = "https://github.com/maurosoria/dirsearch";
    license = lib.licenses.gpl2Only;
    mainProgram = "dirsearch";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
