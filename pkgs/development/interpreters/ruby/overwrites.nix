{ xapianBindings }:
gems:

{
  xapian_full = xapianBindings.merge { cfg = { rubySupport = true; }; };
}
