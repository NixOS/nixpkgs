{
  yarn-berry,
  ...
}@args:

yarn-berry.override (
  {
    berryVersion = 3;
  }
  // removeAttrs args [ "yarn-berry" ]
)
