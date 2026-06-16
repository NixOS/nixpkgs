{
  wireshark,
  ...
}@args:

wireshark.override (
  {
    withQt = false;
  }
  // removeAttrs args [ "wireshark" ]
)
