{
  lib,
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.vdirsyncer.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ lib.concatAttrValues old.optional-dependencies;
  })
)
