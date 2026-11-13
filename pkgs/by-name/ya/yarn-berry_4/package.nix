{
  yarn-berry,
  ...
}@args:

yarn-berry.override (
  {
    berryVersion = 4;
  }
  // removeAttrs args [ "yarn-berry" ]
)
