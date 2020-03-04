defmodule NixTest do
  @fake_package "asanotehhhuh"
  @fetchgit_package "polybar"
  @fetchgithub_package "notes-up"

  use ExUnit.Case

  import NixpkgsGitHubUpdate.Nix

  def check_for_nix(_context) do
    try do
      executable()
    rescue
      RuntimeError ->
        IO.puts("You need Nix installed to run these tests.")
        System.halt(127)
    end

    :ok
  end

  setup_all :check_for_nix

  describe "evaluation tests" do
    test "evaluation handling" do
      exists_attr = "nixpkgs.#{@fetchgithub_package}"

      assert is_binary(eval!(exists_attr)) == true
      catch_error(eval!(@fake_package) == 1)
    end

    # This should always be true or false
    test "package exists?" do
      assert attribute_exists?(@fetchgithub_package) == true
      assert attribute_exists?(@fake_package) == false
    end
  end

  test "owner repo" do
    assert get_url_attr(@fetchgit_package) == "url"
    assert get_url_attr(@fetchgithub_package) == "urls"

    assert get_owner_repo(@fetchgit_package) ==
             {@fetchgit_package, @fetchgit_package}

    assert get_owner_repo(@fetchgithub_package) ==
             {"Philip-Scott", String.capitalize(@fetchgithub_package)}
  end
end
