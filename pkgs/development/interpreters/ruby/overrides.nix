{ xapianBindings }:

{
  xapian_full = xapianBindings.merge { cfg = { rubySupport = true; }; };
}
