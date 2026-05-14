{ python3Packages }:
with python3Packages;
toPythonApplication (
  trezor.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ oldAttrs.optional-dependencies.full;
  })
)
