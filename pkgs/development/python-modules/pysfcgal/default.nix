{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  fetchpatch,
  pytestCheckHook,

  cffi,
  icontract,
  setuptools,
  sfcgal,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysfcgal";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "sfcgal";
    repo = "pysfcgal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-43+AFnXL5fTmLJBlkJrBC87xY5WRYwwwNJgRGfQqB3Y=";
  };

  patches = [
    # Skip test_extrude_straight_skeleton_with_angles on Darwin, https://gitlab.com/sfcgal/pysfcgal/-/merge_requests/245
    (fetchpatch {
      url = "https://gitlab.com/sfcgal/pysfcgal/-/commit/03ab73d62209d041f05a1563682ba812509cef8b.patch";
      hash = "sha256-y1hQRxfR7MBnGLK0LtKEHewdo6O8406noeJ3sItgmco=";
    })
    # Fix test_boundary, https://gitlab.com/sfcgal/pysfcgal/-/merge_requests/246
    (fetchpatch {
      url = "https://gitlab.com/sfcgal/pysfcgal/-/commit/ac0f26a6860e329519ab3a1035fc5c9bc65020e4.patch";
      hash = "sha256-vehPPX4brPWOgQg5bCk9kcMj85z70/IpC8ynGdg9Lr8=";
    })
    # Fix test_solid_split_3d, https://gitlab.com/sfcgal/pysfcgal/-/merge_requests/248
    (fetchpatch {
      url = "https://gitlab.com/sfcgal/pysfcgal/-/commit/0f56c0f0aaa92cc2a8542b16974ff80933cd1682.patch";
      hash = "sha256-DtvWgJ8AqRK+bt5HVKhY02Us8Bl+AjhBQ2ob0d4knQ0=";
    })
    # Fix test_create_from_base_class, https://gitlab.com/sfcgal/pysfcgal/-/merge_requests/249
    (fetchpatch {
      url = "https://gitlab.com/sfcgal/pysfcgal/-/commit/faae666b60e1cb03f3533d89d9c30cc8cf92b14a.patch";
      hash = "sha256-tPxVRXAouUbgwLTfZlBp0IaLdJDbzHb+Bu5bS4sJz7I=";
    })
  ];

  buildInputs = [
    sfcgal
  ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    cffi
  ];

  pythonImportsCheck = [
    "pysfcgal"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    icontract
  ];

  # remove src module, so tests use the installed module instead
  preCheck = ''
    rm -rf pysfcgal
  '';

  disabledTests = [
    # this test is failing due to mismatched output
    "test_wrap_geom_segfault"
  ];

  meta = {
    description = "Python wrapper for SFCGAL";
    homepage = "https://gitlab.com/sfcgal/pysfcgal";
    changelog = "https://gitlab.com/sfcgal/pysfcgal/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    teams = with lib.teams; [
      geospatial
      ngi
    ];
  };
})
