import asyncio
from http import HTTPStatus

import django
import msgspec
from django.conf import settings

settings.configure(
    SECRET_KEY="nixpkgs-test",
    ROOT_URLCONF=__name__,
    ALLOWED_HOSTS=["testserver"],
    INSTALLED_APPS=["dmr"],
)
django.setup()

from django.test import AsyncClient, Client
from django.urls import path

from dmr import Body, Controller
from dmr.plugins.msgspec import MsgspecSerializer


class Message(msgspec.Struct):
    text: str


class SyncController(Controller[MsgspecSerializer]):
    def post(self, parsed_body: Body[Message]) -> Message:
        return parsed_body


class AsyncController(Controller[MsgspecSerializer]):
    async def post(self, parsed_body: Body[Message]) -> Message:
        return parsed_body


urlpatterns = [
    path("sync/", SyncController.as_view()),
    path("async/", AsyncController.as_view()),
]

response = Client().post(
    "/sync/", {"text": "hello"}, content_type="application/json"
)
assert response.status_code == HTTPStatus.CREATED, response.content
assert response.json() == {"text": "hello"}

response = Client().post("/sync/", {}, content_type="application/json")
assert response.status_code == HTTPStatus.BAD_REQUEST, response.content


async def check_async():
    response = await AsyncClient().post(
        "/async/", {"text": "hello"}, content_type="application/json"
    )
    assert response.status_code == HTTPStatus.CREATED, response.content
    assert response.json() == {"text": "hello"}


asyncio.run(check_async())
