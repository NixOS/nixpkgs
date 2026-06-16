{
  vlc-bin,
  ...
}@args:

vlc-bin.override (
  {
    variant = "universal";
  }
  // removeAttrs args [ "vlc-bin" ]
)
