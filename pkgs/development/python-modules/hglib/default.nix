{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, substituteAll, python, nose, mercurial }:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c1fa0cb4d332dd6ec8409b04787ceba4623e97fb378656f7cab0b996c6ca3b2";
  };

  patches = [
    (substituteAll {
      src = ./hgpath.patch;
      hg = "${mercurial}/bin/hg";
    })

    # These two patches are needed to fix the tests.
    # They will need to be removed on the next update.
    (fetchpatch {
      url = "https://www.mercurial-scm.org/repo/python-hglib/raw-rev/12e6aaef0f6e";
      sha256 = "159pmhy23gqcc6rkh5jrni8fba4xbhxwcc0jf02wqr7f82kv8a7x";
    })
    (fetchpatch {
      url = "https://www.mercurial-scm.org/repo/python-hglib/raw-rev/1a318162f06f";
      sha256 = "04lxfc15m3yw5kvp133xg8zv09l8kndi146xk3lnbbm07fgcnn1z";
    })
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} test.py --with-hg "${mercurial}/bin/hg" -v \
      --exclude=test_merge_prompt_cb # https://bz.mercurial-scm.org/show_bug.cgi?id=6265
  '';

  meta = with stdenv.lib; {
    description = "Mercurial Python library";
    homepage = "http://selenic.com/repo/python-hglib";
    license = licenses.mit;
    maintainers = with maintainers; [ dfoxfranke ];
    platforms = platforms.all;
  };
}
