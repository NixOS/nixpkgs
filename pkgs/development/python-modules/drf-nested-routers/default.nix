{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  ipdb,
}:

buildPythonPackage rec {
  pname = "drf-nested-routers";
  version = "0.93.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alanjds";
    repo = "drf-nested-routers";
    rev = "refs/tags/v${version}";
    hash = "sha256-qlXNDydoQJ9FZB6G7yV/pNmx3BEo+lvRqsfjrvlbdNY=";
  };

  patches = [
    # django4 compatibility
    (fetchpatch {
      url = "https://github.com/alanjds/drf-nested-routers/commit/59764cc356f7f593422b26845a9dfac0ad196120.patch";
      hash = "sha256-mq3vLHzQlGl2EReJ5mVVQMMcYgGIVt/T+qi1STtQ0aI=";
    })
    (fetchpatch {
      url = "https://github.com/alanjds/drf-nested-routers/commit/723a5729dd2ffcb66fe315f229789ca454986fa4.patch";
      hash = "sha256-UCbBjwlidqsJ9vEEWlGzfqqMOr0xuB2TAaUxHsLzFfU=";
    })
    (fetchpatch {
      url = "https://github.com/alanjds/drf-nested-routers/commit/38e49eb73759bc7dcaaa9166169590f5315e1278.patch";
      hash = "sha256-IW4BLhHHhXDUZqHaXg46qWoQ89pMXv0ZxKjOCTnDcI0=";
    })
  ];

  buildInputs = [ django ];

  propagatedBuildInputs = [ djangorestframework ];

  nativeCheckInputs = [
    ipdb
    pytestCheckHook
    pytest-django
  ];

  meta = with lib; {
    homepage = "https://github.com/alanjds/drf-nested-routers";
    description = "Provides routers and fields to create nested resources in the Django Rest Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr ];
  };
}
